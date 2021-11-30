auto_auth {
        method "approle" {
                config = {
                    role_id_file_path = ".role-id"
                    secret_id_file_path = ".secret-id"
                }
        }

        sink "file" {
                config = {
                        path = "token-sink"
                }
        }
}
