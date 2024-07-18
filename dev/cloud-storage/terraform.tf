variable "access_token_expiry" {
  type    = string
  default = "600s"
}

variable "project" {
  type = object({
    name = optional(string), service_account = optional(string)
  })
}
