
resource "google_storage_bucket" "bucket" {
  name     = var.bucket
  location = var.region
}

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
  bucket = google_storage_bucket.bucket.name
  source = var.grant
}
