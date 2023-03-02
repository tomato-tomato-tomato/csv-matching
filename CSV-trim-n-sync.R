# Set the directory where the files are stored
setwd("/users/manvisethi/FIT/cleancsvs")

# Create a vector of all the participant IDs in the directory
participant_ids <- unique(gsub("_[cm]_.*", "", list.files(pattern = "[cm]_.*_clean.csv")))

# Loop through each participant ID
for (participant_id in participant_ids) {
  
  # Loop through each event type ("epi" and "psi")
  for (event in c("epi", "psi")) {
    
    # Get the filenames for the child and mother files for the current participant ID and event
    child_filename <- paste0(participant_id, "_c_", event, "_clean.csv")
    mother_filename <- paste0(participant_id, "_m_", event, "_clean.csv")
    
    # Check if both child and mother files exist for the current participant ID and event
    if (child_filename %in% list.files() & mother_filename %in% list.files()) {
      
      # Read in the child and mother files for the current participant ID and event
      child_data <- read.csv(child_filename)
      mother_data <- read.csv(mother_filename)
      
      # Perform any desired analysis or processing on the child and mother data
      
      ##I know this part WORKS
      # Load CSV files into data frames
      df_child <- child_data
      df_mother <- mother_data
      
      # Remove failed observations
      df_child_filtered <- df_child[df_child$success == 1, ]
      df_mother_filtered <- df_mother[df_mother$success == 1, ]
      
      # Find overlapping timestamps
      min_time <- max(min(df_child_filtered$timestamp), min(df_mother_filtered$timestamp))
      max_time <- min(max(df_child_filtered$timestamp), max(df_mother_filtered$timestamp))
      
      # Trim both data frames to the shared longest continuous sequence of observations
      df_child_trimmed <- df_child_filtered[df_child_filtered$timestamp >= min_time & df_child_filtered$timestamp <= max_time, ]
      df_mother_trimmed <- df_mother_filtered[df_mother_filtered$timestamp >= min_time & df_mother_filtered$timestamp <= max_time, ]
      
      # Trim both data frames to the same length
      min_length <- min(nrow(df_child_trimmed), nrow(df_mother_trimmed))
      df_child_trimmed <- df_child_trimmed[1:min_length, ]
      df_mother_trimmed <- df_mother_trimmed[1:min_length, ]
      
      # Save trimmed data frames as new CSV files
      write.csv(df_child_trimmed, paste0(participant_id, "_c_", event, "_synced.csv"), row.names = FALSE)
      write.csv(df_mother_trimmed, paste0(participant_id, "_m_", event, "_synced.csv"), row.names = FALSE)
      
      
      
      
    }
    
  }
  
}



