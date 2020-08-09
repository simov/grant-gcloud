
locals {
  enabled = (
    var.example == "transport-querystring" ||
    var.example == "transport-session"
  ) ? 1 : 0
}

# -----------------------------------------------------------------------------

# Package

resource "random_string" "callback" {
  count   = local.enabled
  length  = 8
  special = false
  upper   = false
  keepers = {
    md5 = filemd5(var.callback)
  }
}

resource "google_storage_bucket_object" "callback" {
  count  = local.enabled
  name   = "callback-${random_string.callback.0.result}.zip"
  bucket = google_storage_bucket.bucket.name
  source = var.callback
}

# -----------------------------------------------------------------------------

# Google

resource "google_cloudfunctions_function" "hello" {
  count       = local.enabled
  name        = "hello"
  description = "Callback Lambda for Google"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.callback.0.name
  trigger_http          = true
  entry_point           = "handler"

  environment_variables = {
    FIREBASE_PATH = var.firebase_path
    FIREBASE_AUTH = var.firebase_auth
  }
}

resource "google_cloudfunctions_function_iam_member" "hello" {
  count          = local.enabled
  project        = google_cloudfunctions_function.hello.0.project
  region         = google_cloudfunctions_function.hello.0.region
  cloud_function = google_cloudfunctions_function.hello.0.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

# -----------------------------------------------------------------------------

# Twitter

resource "google_cloudfunctions_function" "hi" {
  count       = local.enabled
  name        = "hi"
  description = "Callback Lambda for Twitter"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.callback.0.name
  trigger_http          = true
  entry_point           = "handler"

  environment_variables = {
    FIREBASE_PATH = var.firebase_path
    FIREBASE_AUTH = var.firebase_auth
  }
}

resource "google_cloudfunctions_function_iam_member" "hi" {
  count          = local.enabled
  project        = google_cloudfunctions_function.hi.0.project
  region         = google_cloudfunctions_function.hi.0.region
  cloud_function = google_cloudfunctions_function.hi.0.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
