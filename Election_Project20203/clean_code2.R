
library(tidyverse)

election_master <- read.csv('election_data_master.csv')
mycodebook <- paste(readLines('mycodebook.txt'),
                    collapse = '\n' )


## This variable contains all variables and their codes;
variable_info <- str_extract_all(mycodebook, "V[0-9]+[\\s\\S]*?(?=V[0-9]+|$)")

variable_info_bucket <- variable_info[[1]]


## Example with two variables


my_var_list <- c('V201549x',
                 'V201029',
                 'V201033')

mydata_raw <- election_master %>%
                    select(contains(my_var_list))


### Find the bucket locations for the two variables

variable_string <- paste(my_var_list, collapse = ']|[')

variable_string <- paste('[',variable_string,']', sep = '')
variable_string
## grepl() function returns a logical vector
filter_codition <- grepl(pattern = variable_string,
                         x =  variable_info_bucket)


bucket_locations <- which(filter_codition)
## End bucket location search
#####################################

## Now recode the variables and make the final dataframe
mydata <- mydata_raw[1:20,]
names(mydata) <- my_var_list


j <- 0


for(i in bucket_locations)
{
  j <- j + 1
  cat(variable_info_bucket[i], "\n")
  
  ## Extract all numerical codes and labels 
  mycodes <- str_extract_all(variable_info_bucket,
                             "[-0-9]+[.].+")[[i]]
  mycodes
  
  ## Split the numeric and the labels
  code_values <- str_extract(mycodes, "[-0-9]+")
  code_labels <- str_extract(mycodes, "[A-Z].+")
  
  ## Create a data frame using these codes
  code_data <- data.frame(code_values,
                          code_labels)
  names(code_data)[1] <- my_var_list[j]
  
 
  
  values_of_variable <- data.frame(mydata[, j])
  names(values_of_variable)[1] <- my_var_list[j]
  
  data_with_labels <- merge(values_of_variable,
                            code_data,
                            by = my_var_list[j])
  
  mydata <- cbind(mydata, data_with_labels)
  
}











