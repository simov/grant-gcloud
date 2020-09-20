
resource "google_storage_bucket" "grant" {
  name     = var.bucket
  location = var.region
}

# -----------------------------------------------------------------------------

resource "random_string" "grant" {
  length  = 8
  special = false
  upper   = false
  keepers = {
    md5 = filemd5(var.grant)
  }
}

resource "google_storage_bucket_object" "grant" {
  name   = "${var.lambda}-${random_string.grant.result}.zip"
  bucket = google_storage_bucket.grant.name
  source = var.grant
}

# -----------------------------------------------------------------------------

resource "random_string" "callback" {
  count   = local.callback
  length  = 8
  special = false
  upper   = false
  keepers = {
    md5 = filemd5(var.callback)
  }
}

resource "google_storage_bucket_object" "callback" {
  count  = local.callback
  name   = "callback-${random_string.callback.0.result}.zip"
  bucket = google_storage_bucket.grant.name
  source = var.callback
}
