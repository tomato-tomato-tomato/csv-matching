# Load CSV files into data frames
df1 <- read.csv("F005_c_psi_clean.csv")
df2 <- read.csv("F005_m_psi_clean.csv")

# Remove failed observations
df1_filtered <- df1[df1$success == 1, ]
df2_filtered <- df2[df2$success == 1, ]

# Find overlapping timestamps
min_time <- max(min(df1_filtered$timestamp), min(df2_filtered$timestamp))
max_time <- min(max(df1_filtered$timestamp), max(df2_filtered$timestamp))

# Trim both data frames to the shared longest continuous sequence of observations
df1_trimmed <- df1_filtered[df1_filtered$timestamp >= min_time & df1_filtered$timestamp <= max_time, ]
df2_trimmed <- df2_filtered[df2_filtered$timestamp >= min_time & df2_filtered$timestamp <= max_time, ]

# Trim both data frames to the same length
min_length <- min(nrow(df1_trimmed), nrow(df2_trimmed))
df1_trimmed <- df1_trimmed[1:min_length, ]
df2_trimmed <- df2_trimmed[1:min_length, ]

# Save trimmed data frames as new CSV files
write.csv(df1_trimmed, "file1_trimmed2.csv", row.names = FALSE)
write.csv(df2_trimmed, "file2_trimmed2.csv", row.names = FALSE)

