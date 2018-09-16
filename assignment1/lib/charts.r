library(scatterplot3d)

combine <- function(aa, ba) {
  t <- c(aa, ba)
  names <- sort(names(t))
  end <- 2 * length(names)
  mat <- matrix(c(1:end),ncol=length(names),byrow=TRUE)
  colnames(mat) <- names
  rownames(mat) <- c('above average', 'below average')

  for (n in 1:length(names)) {
    mat[1,n] = aa[names[n]]
    mat[2,n] = ba[names[n]]
  }

  mat[is.na(mat)] <- 0

  return(mat)
}


# KNN Errors
wine_knn_errors <- read.csv('./data/supporting/winequality-knearestneighbor.csv')
mushroom_knn_errors <- read.csv('./data/supporting/agaricus-lepiota-knearestneighbor.csv')

png('./assets/wine_knn_errors.png', 1024, 720)
plot(wine_knn_errors$k, wine_knn_errors$euclidean, ylab='Euclidean and Manhattan Errors', xlab='K', type='l')

png('./assets/mushroom_knn_errors.png', 1024, 720)
plot(mushroom_knn_errors$k, mushroom_knn_errors$euclidean, ylab='Euclidean and Manhattan Errors', xlab='K', type='l')

# Boosting Errors
wine_boost_errors <- read.csv('./data/supporting/winequality-adaboost.csv')
mushroom_boost_errors <- read.csv('./data/supporting/agaricus-lepiota-adaboost.csv')

png('./assets/wine_boost_errors.png', 1024, 720)
plot(wine_boost_errors$iterations, wine_boost_errors$root_mean_squared_error, ylab='RMSE', xlab='Iterations', type='l')

png('./assets/mushroom_boost_errors.png', 1024, 720)
plot(mushroom_boost_errors$iterations, mushroom_boost_errors$root_mean_squared_error, ylab='RMSE', xlab='Iterations', type='l')

# J48 Tree Errors
wine_j48_errors <- read.csv('./data/supporting/winequality-j48tree.csv')
mushroom_j48_errors <- read.csv('./data/supporting/agaricus-lepiota-j48tree.csv')

png('./assets/wine_j48_errors.png', 1024, 720)
scatterplot3d(wine_j48_errors, type='h', highlight.3d=TRUE)

png('./assets/mushroom_j48_errors.png', 1024, 720)
scatterplot3d(mushroom_j48_errors, type='h', highlight.3d=TRUE)

# Neural Network Errors
wine_nn_errors <- read.csv('./data/supporting/winequality-neuralnetwork.csv')
mushroom_nn_errors <- read.csv('./data/supporting/agaricus-lepiota-neuralnetwork.csv')

png('./assets/wine_nn_errors.png', 1024, 720)
plot(wine_nn_errors$epochs, wine_nn_errors$rmse, ylab='RMSE', xlab='Epochs', type='l')

png('./assets/mushroom_nn_errors.png', 1024, 720)
plot(mushroom_nn_errors$epochs, mushroom_nn_errors$rmse, ylab='RMSE', xlab='Epochs', type='l')

# SVM
mse <- read.csv('./data/supporting/agaricus-lepiota-svm.csv')

rbf_mse <- mse[mse$kernel == "rbf",][, c(2,4)]
polynomial <- mse[mse$kernel == "polynomial", ][, c(2:4)]

png('./assets/mushroom_svm_errors.png', 1440, 720)
par(mfrow=c(1,3))

plot(rbf_mse, type='l', main='RBF Mushroom Errors Against C', cex.main=2)
scatterplot3d(polynomial, type='h', highlight.3d=TRUE, main="Polynomial Mushroom Errors against C and degree", cex.main=2)

wine_svm <- read.csv('./data/supporting/winequality-svm.csv')
linear_wine <- wine_svm[wine_svm$kernel == 'linear', ][, c(2,4)]
rbf_wine <- wine_svm[wine_svm$kernel == 'rbf', ][, c(2,4)]

png('./assets/wine_svm_errors.png', 1024, 720)
par(mfrow=c(1,2))

plot(linear_wine, main='Linear Error Decay for Wine', cex.main=2,type='l')
plot(rbf_wine, main='RBF Error Decay for Wine', cex.main=2,type='l')
