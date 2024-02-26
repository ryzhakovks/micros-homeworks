resource "yandex_kms_symmetric_key" "my_symmetric_key" {
  name              = "my-symmetric-key"
  description       = "Key for object storage encryption"
  default_algorithm = "AES_128" # Алгоритм шифрования. Возможные значения: AES-128, AES-192 или AES-256.
  rotation_period   = "8760h"   # 1 год. Период ротации (частота смены версии ключа по умолчанию).
  lifecycle {
    prevent_destroy = true # Защита ключа от удаления (например, командой terraform destroy)
  }
}

resource "yandex_storage_bucket" "my_bucket_qazwsx" {
  access_key = var.access_key_id
  secret_key = var.secret_key
  bucket     = "my-bucket-qazwsx"
  max_size   = 100000

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.my_symmetric_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
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

resource "local_file" "index_html" {
  content = templatefile("${abspath(path.module)}/web-app.tftpl",
    {
      bucket = yandex_storage_bucket.my_bucket_qazwsx
      object = yandex_storage_object.content_bg
    }
  )
  filename = "${abspath(path.module)}/../content/index.html"
}

resource "yandex_storage_object" "index_html" {
  depends_on = [yandex_storage_bucket.my_bucket_qazwsx]
  access_key = var.access_key_id
  secret_key = var.secret_key
  bucket     = "my-bucket-qazwsx"
  key        = "index.html"
  source     = local_file.index_html.filename
  acl        = "public-read"
}
