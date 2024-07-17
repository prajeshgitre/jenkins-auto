
variable "service_accounts_list" {
  description = "variable for creating service account"
  type = list(object({
    project_id    = string
    prefix        = string
    names         = list(string)
    project_roles = list(string)
    display_name  = string
  }))
  default = []
}

variable "rachith" {
  default = "rach"

}