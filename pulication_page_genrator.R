# Read the publications data from CSV
my_data <- read.csv(file = "references.csv", 
                    header = TRUE, 
                    stringsAsFactors = FALSE)

# Create output file with Hugo frontmatter
output_file <- "content/publications.md"
sink(output_file)

# Write Hugo frontmatter
cat("---\n")
cat("title: \"Publications\"\n")
cat("date: 2025-01-01\n")
cat("menu: \"main\"\n")
cat("weight: 4\n")
cat("---\n\n")

# Sort by year and row number
my_data$Row <- row.names(my_data)
my_data <- my_data[order(my_data$Year, as.numeric(my_data$Row), 
                         decreasing = c(TRUE, TRUE)), ]
years <- sort(unique(my_data$Year), decreasing = TRUE)

# Generate publications by year
for(year in years){
  cat(paste("\n","## ",year,"\n",sep=""))
  thisyear <- my_data[my_data$Year == year,]
  if(dim(thisyear)[1] > 0){
    cat("\n<ul>\n")
    for(i in 1:(dim(thisyear)[1])){
      cat(paste("<li>",sep = ""))
      cat(paste(thisyear$Author[i], " (",year,"). ", "<strong>",thisyear$Title[i], "</strong>. ", sep=""))
      if(!is.na(thisyear$Journal[i]) && nchar(trimws(thisyear$Journal[i])) > 0){
        cat(paste("<i>",thisyear$Journal[i],"</i>. ",sep="")) 
      }
      if(!is.na(thisyear$Details[i]) && nchar(trimws(thisyear$Details[i])) > 0){ 
        cat(paste(thisyear$Details[i],". ",sep="")) 
      }
      
      if(!is.na(thisyear$DOI[i]) && nchar(trimws(thisyear$DOI[i])) > 0){
        cat(paste(" <a href=\"http://dx.doi.org/",thisyear$DOI[i],"\" target=\"_blank\">[DOI]</a>",sep=""))  
      }
      cat("</li>\n")
    }
    cat("</ul>\n")
  }
}

sink()