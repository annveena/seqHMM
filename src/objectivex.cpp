#include "seqHMM.h"
using namespace Rcpp;

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]

List objectivex(NumericVector transitionMatrix, NumericVector emissionArray, NumericVector initialProbs,
  IntegerVector obsArray, IntegerVector transNZ, IntegerVector emissNZ, IntegerVector initNZ, IntegerVector nSymbols,
  NumericMatrix coefs, NumericMatrix X_, IntegerVector numberOfStates) { 
  
  
  IntegerVector eDims = emissionArray.attr("dim"); //m,p,r
  IntegerVector oDims = obsArray.attr("dim"); //k,n,r
  
  arma::vec init(initialProbs.begin(),eDims[0],false);
  arma::mat transition(transitionMatrix.begin(),eDims[0],eDims[0],false);
  arma::cube emission(emissionArray.begin(), eDims[0], eDims[1],eDims[2],false);
  arma::icube obs(obsArray.begin(), oDims[0], oDims[1],oDims[2],false); 
  arma::imat ANZ(transNZ.begin(),eDims[0],eDims[0],false);
  arma::icube BNZ(emissNZ.begin(), eDims[0], eDims[1]-1,eDims[2],false);
  arma::ivec INZ(initNZ.begin(), eDims[0],false);
  
  
  
  int q = coefs.nrow();
  arma::vec grad(arma::accu(ANZ) + arma::accu(BNZ) + arma::accu(INZ) + (numberOfStates.size()-1)*q ,arma::fill::zeros);
  arma::mat coef(coefs.begin(),q,numberOfStates.size());
  coef.col(0).zeros();
  arma::mat X(X_.begin(),oDims[0],q);
  arma::mat lweights = exp(X*coef).t();
  if(!lweights.is_finite()){
    grad.fill(-std::numeric_limits<double>::max());
    return List::create(Named("objective") = std::numeric_limits<double>::max(), Named("gradient") = wrap(grad));
  }
  
  lweights.each_row() /= sum(lweights,0);
   
  arma::mat initk(eDims[0],oDims[0]);
  for(int k = 0; k < oDims[0]; k++){    
    initk.col(k) = init % reparma(lweights.col(k),numberOfStates);
  }
  
  arma::cube alpha(eDims[0],oDims[1],oDims[0]); //m,n,k
  arma::cube beta(eDims[0],oDims[1],oDims[0]); //m,n,k 
  arma::mat scales(oDims[1],oDims[0]); //m,n,k
  
  internalForwardx(transition, emission, initk, obs, alpha, scales);
  internalBackward(transition, emission, obs, beta, scales);     
  
  arma::rowvec ll = arma::sum(log(scales));
  
  int countgrad = 0;
  IntegerVector cumsumstate = cumsum(numberOfStates);
  
  // transitionMatrix
  if(arma::accu(ANZ)>0){
    for(unsigned int jj = 0; jj < numberOfStates.size(); jj++){
      arma::vec gradArow(numberOfStates(jj));
      arma::mat gradA(numberOfStates(jj),numberOfStates(jj));
      for(int i = 0; i < numberOfStates(jj); i++){
        arma::uvec ind = arma::find(ANZ.row(cumsumstate(jj)-numberOfStates(jj)+i).subvec(cumsumstate(jj)-numberOfStates(jj),cumsumstate(jj)-1));  
        
        if(ind.n_elem>0){ 
          gradArow.zeros();
          gradA.eye();
          gradA.each_row() -= transition.row(cumsumstate(jj)-numberOfStates(jj)+i).subvec(cumsumstate(jj)-numberOfStates(jj),cumsumstate(jj)-1);
          gradA.each_col() %= transition.row(cumsumstate(jj)-numberOfStates(jj)+i).subvec(cumsumstate(jj)-numberOfStates(jj),cumsumstate(jj)-1).t();
          
          for(int k = 0; k < oDims[0]; k++){
            for(int t = 0; t < (oDims[1]-1); t++){
              for(int j = 0; j < numberOfStates(jj); j++){ 
                double tmp = 1.0;
                for(int r = 0; r < oDims[2]; r++){
                  tmp *= emission(cumsumstate(jj)-numberOfStates(jj)+j,obs(k,t+1,r),r);
                }
                gradArow(j) += alpha(cumsumstate(jj)-numberOfStates(jj)+i,t,k) * tmp * beta(cumsumstate(jj)-numberOfStates(jj)+j,t+1,k) / scales(t+1,k);               }
              
            }
          }
          gradArow = gradA * gradArow;
          grad.subvec(countgrad,countgrad+ind.n_elem-1) = gradArow.rows(ind);
          countgrad += ind.n_elem;
        }
      }
    }
  }
  if(arma::accu(BNZ)>0){
    // emissionMatrix
    for(int r=0; r < oDims[2]; r++){
      arma::vec gradBrow(nSymbols[r]);
      arma::mat gradB(nSymbols[r],nSymbols[r]);
      for(int i = 0; i < eDims[0]; i++){
        arma::uvec ind = arma::find(BNZ.slice(r).row(i));
        if(ind.n_elem>0){
          gradBrow.zeros();
          gradB.eye();
          gradB.each_row() -= emission.slice(r).row(i).subvec(0,nSymbols[r]-1);
          gradB.each_col() %= emission.slice(r).row(i).subvec(0,nSymbols[r]-1).t();
          for(unsigned int j = 0; j < nSymbols[r]; j++){
            for(int k = 0; k < oDims[0]; k++){
              if(obs(k,0,r) == j){
                double tmp = 1.0;
                for(int r2 = 0; r2 < oDims[2]; r2++){
                  if(r2 != r){
                    tmp *= emission(i,obs(k,0,r2),r2);
                  }
                }
                gradBrow(j) += initk(i,k) * tmp * beta(i,0,k) / scales(0,k);
              }
              for(int t = 0; t < (oDims[1]-1); t++){ 
                if(obs(k,t+1,r) == j){
                  double tmp = 1.0;
                  for(int r2 = 0; r2 < oDims[2]; r2++){
                    if(r2 != r){
                      tmp *= emission(i,obs(k,t+1,r2),r2);
                    }
                  }
                  gradBrow(j) += arma::dot(alpha.slice(k).col(t),transition.col(i)) * tmp * beta(i,t+1,k) / scales(t+1,k);
                }
              }
            }
          }
          gradBrow = gradB * gradBrow;
          grad.subvec(countgrad,countgrad+ind.n_elem-1) = gradBrow.rows(ind);
          countgrad += ind.n_elem;
          
        }
      }
    }
  }
  if(arma::accu(INZ)>0){
    for(unsigned int i = 0; i < numberOfStates.size(); i++){
      arma::uvec ind = arma::find(INZ.subvec(cumsumstate(i)-numberOfStates(i),cumsumstate(i)-1));  
      if(ind.n_elem>0){     
        arma::vec gradIrow(numberOfStates(i),arma::fill::zeros);  
        for(unsigned int j = 0; j < numberOfStates(i); j++){        
          for(int k = 0; k < oDims[0]; k++){ 
            double tmp = 1.0;
            for(int r=0; r < oDims[2]; r++){
              tmp *= emission(cumsumstate(i)-numberOfStates(i)+j,obs(k,0,r),r);
            }
            gradIrow(j) += tmp * beta(cumsumstate(i)-numberOfStates(i)+j,0,k) / scales(0,k) * lweights(i,k);           
          }
        }
        arma::mat gradI(numberOfStates(i),numberOfStates(i),arma::fill::zeros);
        gradI.eye();
        gradI.each_row() -= init.subvec(cumsumstate(i)-numberOfStates(i),cumsumstate(i)-1).t();
        gradI.each_col() %= init.subvec(cumsumstate(i)-numberOfStates(i),cumsumstate(i)-1);
        gradIrow = gradI * gradIrow;
        grad.subvec(countgrad,countgrad+ind.n_elem-1) = gradIrow.rows(ind);
        countgrad += ind.n_elem;
      }
    }
  }
  
  for(unsigned int jj = 1; jj < numberOfStates.size(); jj++){
    for(int k = 0; k < oDims[0]; k++){
      for(unsigned int j = 0; j < eDims[0]; j++){                
        double tmp = 1.0;
        for(int r=0; r < oDims[2]; r++){
          tmp *= emission(j,obs(k,0,r),r);
        }        
        if(j>=(cumsumstate(jj)-numberOfStates(jj)) & j<cumsumstate(jj)){
          grad.subvec(countgrad+q*(jj-1),countgrad+q*jj-1) += 
            tmp * beta(j,0,k) / scales(0,k) * initk(j,k) * X.row(k).t() * (1.0 - lweights(jj,k)); 
        } else {
          grad.subvec(countgrad+q*(jj-1),countgrad+q*jj-1) -= 
            tmp * beta(j,0,k) / scales(0,k) * initk(j,k) *X.row(k).t() * lweights(jj,k);
        }
      }
    }
  }
  return List::create(Named("objective") = -sum(ll), Named("gradient") = wrap(-grad));
}