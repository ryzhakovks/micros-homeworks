variable "ip_address" {
    type          = string
    description   = "Example to validate IP address."
    validation {
        condition = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",var.ip_address))
        error_message = "Invalid IP address provided."
    }
}

variable "ip_address_IPv4" {
  type = string

  validation {
    condition     = can(cidrnetmask("${var.ip_address_IPv4}/32"))
    error_message = "Must be a valid IPv4 CIDR block address."
  }
}

variable "ip_addresses" {
  type        = list(string)
  description = "list of ip-idresses"
  validation {
    condition = alltrue([
      for a in var.ip_addresses : can(cidrnetmask("${a}/32"))
    ])
    error_message = "All elements must be valid IPv4 addresses."
  }
}

variable "lower_case_string" {
  type        = string
  description = "any string"
  validation {
    condition     = lower(var.lower_case_string) == var.lower_case_string
    error_message = "String must not contain uppercase characters"
  }
}


variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = true
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = var.in_the_end_there_can_be_only_one.Dunkan != var.in_the_end_there_can_be_only_one.Connor
    }
}

