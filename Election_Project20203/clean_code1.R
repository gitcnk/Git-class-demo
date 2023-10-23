library(pdftools)
library(tidyverse)
mytext <- pdf_text(pdf = 'testpdf.pdf')

cat(mytext, sep = '\n', file = 'mycodebook.txt')

mycodebook <- paste(readLines('mycodebook.txt'), collapse = '\n' )


## This variable contains all variables and their codes;
variable_info <- str_extract_all(mycodebook, "V[0-9]+[\\s\\S]*?(?=V[0-9]+|$)")

variable_info_bucket <- variable_info[[1]]



## Let's play with bucket 100
# Visualize the bucket
cat(variable_info_bucket[100], "\n")


## Extract all numerical codes and labels 
mycodes <- str_extract_all(new_bucket, "[-0-9]+[.].+")[[100]]
mycodes


## Split the numeric and the labels
code_values <- str_extract(mycodes, "[-0-9]+")
code_labels <- str_extract(mycodes, "[A-Z].+")

## Create a data frame using these codes
code_data <- data.frame(myvar = code_values,
                        code_labels)


## Create a test data frame to play with
## to see how the recoding be done

test_data <- data.frame(myvar = c(-9,1,1,-8,11,5,-9, 1,1,-1))

test_data_with_labels <- merge(test_data,
                               code_data,
                               by = 'myvar')




mydata_race <- election_data_master %>%
                  select(contains(c('V201549x',
                                    'V201029',
                                    'V201033')))


filter_codition <- grepl('V201549x|V201617x', variable_info_bucket)

bucket_locations <- which(filter_codition)

