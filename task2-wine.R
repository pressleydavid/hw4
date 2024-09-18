# Task 2 - Combining Excel and Delimited Data
library(tidyverse)

## 1. Download, Import, Print tibble
excel_sheets("./raw/white-wine.xlsx")

tibble(read_xlsx(path = "./raw/white-wine.xlsx", sheet="white-wine"))

## 2. Overwrite columns with values from the 'variables' sheet
col_names <- read_xlsx(path = "./raw/white-wine.xlsx", sheet="variables")

## 3. AAdd column 'type' with char values of 'white'
white_wine <- tibble(read_xlsx(path = "./raw/white-wine.xlsx", sheet="white-wine")) |>
                     setNames(col_names$Variables) |>
                     mutate(type = "white")

## 4a. Read (readr) semi-colon delimited red wine data.
## 4b. Replace col names as above
## 4c. Add column for 'type'
red_wine <- read_delim("./raw/red-wine.csv", delim = ";") |>
    setNames(col_names$Variables) |>
    mutate(type = "red")

## 5. Merge the two tibbles with bind_rows
combined_wine <- bind_rows(white_wine, red_wine)

## 6. filter for: quality > 6.5 and alcohol < 132
## 7. sort from highest quality to lowest
## 8. select variables that contain `acid`, `alcohol`, `type`, and `quality`
## 9. add mean and std dev of `alcohol` across `quality`
combined_wine <- bind_rows(white_wine, red_wine) |>
                filter(quality > 6.5 & alcohol <132) |>
                arrange(desc(quality)) |>
                select(contains("acid"), alcohol, type, quality) |>
                group_by(quality) |>
                mutate(
                    mean_alcohol = mean(alcohol, na.rm = TRUE),
                    sd_alcohol = sd(alcohol, na.rm = TRUE)
                )
