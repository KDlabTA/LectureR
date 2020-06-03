################################
rm(list=ls())
################################
# named list inversion
# ============================================================================== #
# Try 4-1.
# (1) Create a list with four elements of different data types
# (2) Write a function to reverse the order of four elements in the list
# Limitation: Try NOT to use any of the available commands such as rev().
# ============================================================================== #
# Solution
ex <- list(num = 1:3, abc = letters[4:7], op = "+-*/", XYZ = LETTERS[-c(1:20)])
rev(ex)
#
revList <- function(LL){ 
  ans <- LL
  names(ans) <- NULL
  for (i in 1:length(LL)){
    ans[i] <- LL[length(LL)-i+1]
    names(ans)[i] <- names(LL[length(LL)-i+1])
  } # for
  return(ans);
} # revList
revList(ex)
# ex[length(ex):1]
################################
