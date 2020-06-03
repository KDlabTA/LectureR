################################
rm(list=ls())
################################
# 3D array
# ============================================================================== #
# (1) Create a 3D array of 24 integers with dimensions (4, 3, 2)
# (2) Add a unique name to every column for each dimension
# (3) Write a function to find the maximum of each column along the given dimension
# Example: input array A =
#                         , , h
#                         e  f  g
#                      a  4 55 63
#                      b 45 88 15
#                      c 74 44 13
#                      d 41 17 77
#                         , , i
#                         e  f  g
#                      a  97  3 86
#                      b  78 62 66
#                      c  84 46 64
#                      d 100 65 96
# getMax(A,1)=(97,88,84,100), getMax(A,2)=(100,88,96), getMax(A,3)=(88,100)
# ==============================================================================
# Solution 1.
A <- array(sample(1:100,24), dim = c(4, 3, 2))
dimnames(A) <- list(letters[1:4], letters[5:7], letters[8:9])
#
getMax <- function(A, d=1) {
  # d = 1
  ans <- NULL
  for (i in 1:dim(A)[d]) {
    # i = 1
    if (d == 1){
      y <- max(A[i, , ])
    } else if (d == 2) {
      y <- max(A[, i, ])
    } else if (d == 3) {
      y <- max(A[, , i])
    }
    ans <- c(ans, y)
    # i = i+1
  } # for
  return(ans);
} # end getMax
getMax(A)
getMax(A,3)
# ------------------------------
# Another version using switch()
getMin <- function(B, d=1) {
  # B = A; d = 1
  ans <- NULL
  for (i in 1:dim(B)[d]) {
    # i = 1
    y <- switch(d, min(B[i, , ]), min(B[, i, ]), min(B[, , i]))
    ans <- c(ans, y)
    # i = i+1
  } # for
  return(ans);
} # getMin
B <- array(sample(1:100,24), dim = c(2, 3, 4))
dimnames(B) <- list(letters[1:2], letters[3:5], letters[6:9])
getMin(B)
getMin(B,3)
# ------------------------------
# Solution for any number of dimensions & any statistical function
getStat = function(A, fun=max){
  # fun = max
  idx <-arrayInd(seq(A),dim(A));  # array index of each element
  ans <- NULL;
  for (d in 1:dim(idx)[2]) {
    # d = 1
    oneD <- NULL;
    for (i in 1:max(idx[, d])) {
      # i = 1
      y <- do.call(fun, as.list(A[ which(idx[, d]==i) ]))
      oneD <- c(oneD, y)
      # i = i+1
    } # inner for
    ans[d] <- list(oneD);
    # d = d+1
    # names(ans[[d]]) <- dimnames(C)[[d]]
  } # outer for
  return(ans);
} # end getStat
C <- array(sample(1:100,72), dim = c(4, 3, 2, 3))
dimnames(C) <- list(LETTERS[1:4], LETTERS[5:7], LETTERS[8:9], LETTERS[10:12])
getStat(C)
getStat(C,min)
getStat(C,sum)
# lapply(getStat(C,sum), max)
################################