
resource "google_cloudfunctions_function" "grant" {
  name        = var.lambda
  description = "OAuth Simplified"
  runtime     = "nodejs10"
  region      = var.region

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.grant.name
  source_archive_object = google_storage_bucket_object.grant.name
  trigger_http          = true
  entry_point           = "handler"

  environment_variables = {
    FIREBASE_PATH = var.firebase_path
    FIREBASE_AUTH = var.firebase_auth
  }
}

output "https_trigger_url" {
  value = google_cloudfunctions_function.grant.https_trigger_url
}

# -----------------------------------------------------------------------------

resource "google_cloudfunctions_function" "hello" {
  count       = local.callback
  name        = "hello"
  description = "Callback Lambda for Google"
  runtime     = "nodejs10"
  region      = var.region

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.grant.name
  source_archive_object = google_storage_bucket_object.callback.0.name
  trigger_http          = true
  entry_point           = "handler"

  environment_variables = {
    FIREBASE_PATH = var.firebase_path
    FIREBASE_AUTH = var.firebase_auth
  }
}

resource "google_cloudfunctions_function" "hi" {
  count       = local.callback
  name        = "hi"
  description = "Callback Lambda for Twitter"
  runtime     = "nodejs10"
  region      = var.region

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.grant.name
  source_archive_object = google_storage_bucket_object.callback.0.name
  trigger_http          = true
  entry_point           = "handler"

  environment_variables = {
    FIREBASE_PATH = var.firebase_path
    FIREBASE_AUTH = var.firebase_auth
  }
}
