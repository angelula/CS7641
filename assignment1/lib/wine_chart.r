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

plothist <- function(below_average, above_average, column) {
  below_average_counts <- table(below_average[column][,1])
  above_average_counts <- table(above_average[column][,1])
  counts <- combine(above_average_counts, below_average_counts)
  barplot(counts, main=column, col=c('green', 'red'), cex.main=2, cex.lab=1.5)
}

# Graph for wine distribution of data
png('./assets/wine_distribution.png', 1024, 720)
par(mfrow=c(4,3))
wh <- read.csv('./data/wine_data/winequality-white.csv')
re <- read.csv('./data/wine_data/winequality-red.csv')
to <- rbind(wh,re)
above_average <- to[to$quality >= 6, ]
below_average <- to[to$quality < 6, ]
labels <- labels(wh)[[2]]

for (l in labels) {
  print(l);
  plothist(below_average,above_average, l)
}

# KNN Errors
wine_knn_errors <- read.csv('./data/supporting/winequality-knearestneighbor.csv')
png('./assets/wine_knn_errors.png', 1024, 720)
plot(wine_knn_errors$k, wine_knn_errors$euclidean, ylab='Euclidean and Manhattan Errors', xlab='K', type='l')

# Boosting Errors
wine_boost_errors <- read.csv('./data/supporting/winequality-adaboost.csv')
png('./assets/wine_boost_errors.png', 1024, 720)
plot(wine_boost_errors$iterations, wine_boost_errors$root_mean_squared_error, ylab='RMSE', xlab='Iterations', type='l')

# J48 Tree Errors
wine_j48_errors <- read.csv('./data/supporting/winequality-j48tree.csv')
png('./assets/wine_j48_errors.png', 1024, 720)
scatterplot3d(wine_j48_errors, type='h', highlight.3d=TRUE)

# Neural Network Errors
wine_nn_errors <- read.csv('./data/supporting/winequality-neuralnetwork.csv')
png('./assets/wine_nn_errors.png', 1024, 720)
plot(wine_nn_errors$epochs, wine_nn_errors$rmse, ylab='RMSE', xlab='Epochs', type='l')

# SVM
wine_svm <- read.csv('./data/supporting/winequality-svm.csv')
#linear_wine <- wine_svm[wine_svm$kernel == 'linear', ][, c(2,4)]
rbf_wine <- wine_svm[wine_svm$kernel == 'rbf', ][, c(2,4)]

png('./assets/wine_svm_errors.png', 1024, 720)
par(mfrow=c(1,2))

#plot(linear_wine, main='Linear Error Decay for Wine', cex.main=2,type='l')
plot(rbf_wine, main='RBF Error Decay for Wine', cex.main=2,type='l')
