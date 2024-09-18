# Task 2 - Yeast Data
# yeast_data <- read_table("./raw/yeast.data", col_names = FALSE)
yeast_data <- read_table("https://www4.stat.ncsu.edu/~online/datasets/yeast.data",
                         col_names = c("seq_name","mcg","gvh","alm","mit","erl","pox","vac","nuc",
                                       "class")) |>
                select(-seq_name,-nuc) |>
                group_by(class) |>
                #mutate(mean_mcg = mean(mcg, na.rm = TRUE)) |>
                summarize(across(where(is.numeric),
                    .fns = list(mean = ~ mean(.x, na.rm = TRUE),
                                median = ~ median(.x, na.rm = TRUE)),
                    .names = "{.fn}_{.col}"))
                # summarize(across(where(is.numeric),
                #     .fns = list(median = ~ median(.x, na.rm=TRUE)),
                #     .names = "median_{.col}"))

              # summarize(where(is.numeric), \(x) mean(x, na.rm=TRUE))
print(yeast_data)

#select(class, contains(c("mean", "median")), everything())

# check
check_cyt <- read_table("https://www4.stat.ncsu.edu/~online/datasets/yeast.data",
           col_names = c("seq_name","mcg","gvh","alm","mit","erl","pox","vac","nuc",
                         "class")) |>
    select(-seq_name,-nuc) |>
    group_by(class) |>
    summarize(mcg_mean = mean(mcg, na.rm = TRUE))
