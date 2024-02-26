
output "yandex_storage_object_content_bg_url" {
  value = "https://${yandex_storage_bucket.my_bucket_qazwsx.bucket_domain_name}/${yandex_storage_object.content_bg.key}"
}

output "yandex_storage_object_index_html_url" {
  value = "https://${yandex_storage_bucket.my_bucket_qazwsx.bucket_domain_name}/${yandex_storage_object.index_html.key}"
}
