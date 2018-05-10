

library(hash)
x <- read.table("/Users/davidgibbs/Downloads/c7.all.v6.1.symbols.gmt", sep="^", stringsAsFactors=F)
h <- hash()
for (i in 1:length(x[[1]])) {
  bits <- unlist(strsplit(x=as.character(x[[1]][i]), split="\t"))
  print(i)
  print(bits[1])
  h[[bits[1]]] <- bits[-c(1,2)]
}
