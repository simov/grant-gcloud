
resource "google_cloudfunctions_function_iam_member" "grant" {
  project        = google_cloudfunctions_function.grant.project
  region         = google_cloudfunctions_function.grant.region
  cloud_function = google_cloudfunctions_function.grant.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}
