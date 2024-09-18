# Task 2 - Glass Data
glass_data <- read_csv("https://www4.stat.ncsu.edu/~online/datasets/glass.data",
    col_names = c("Id", "RI", "Na", "Mg", "Al", "Si", "K", "Ca", "Ba", "Fe")) |>
    mutate(glass_type_c = factor(X11, levels = 1:7, 
                                 labels = c("building_windows_float_processed",
                                            "building_windows_non_float_processed",
                                            "vehicle_windows_float_processed",
                                            "vehicle_windows_non_float_processed",
                                            "containers",
                                            "tableware",
                                            "headlamp"))) |>
    rename(glass_type_n = X11) |>
    filter(glass_type_c %in% c("tableware","headlamp") & Fe < 0.2)

print(glass_data)
