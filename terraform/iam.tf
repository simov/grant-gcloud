
resource "google_cloudfunctions_function_iam_member" "grant" {
  project        = google_cloudfunctions_function.grant.project
  region         = google_cloudfunctions_function.grant.region
  cloud_function = google_cloudfunctions_function.grant.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_cloudfunctions_function_iam_member" "hello" {
  count          = local.callback
  project        = google_cloudfunctions_function.hello.0.project
  region         = google_cloudfunctions_function.hello.0.region
  cloud_function = google_cloudfunctions_function.hello.0.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}

resource "google_cloudfunctions_function_iam_member" "hi" {
  count          = local.callback
  project        = google_cloudfunctions_function.hi.0.project
  region         = google_cloudfunctions_function.hi.0.region
  cloud_function = google_cloudfunctions_function.hi.0.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
