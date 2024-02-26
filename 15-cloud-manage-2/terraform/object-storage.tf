resource "yandex_storage_bucket" "my_bucket_qazwsx" {
  access_key = var.access_key_id
  secret_key = var.secret_key
  bucket     = "my-bucket-qazwsx"
  max_size   = 100000
}

resource "yandex_storage_object" "content_bg" {
  depends_on = [yandex_storage_bucket.my_bucket_qazwsx]
  access_key = var.access_key_id
  secret_key = var.secret_key
  bucket     = "my-bucket-qazwsx"
  key        = "test-img.jpg"
  source     = "../content/test-img.jpg"
  acl        = "public-read"
}
