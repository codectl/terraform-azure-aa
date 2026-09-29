module "naming" {
  source  = "codectl/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "regions" {
  source  = "codectl/locations/azure"
  version = "~> 1.0"

  location = {
    primary = "swedencentral"
  }
}

module "rg" {
  source  = "codectl/rg/azure"
  version = "~> 1.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = module.regions.location.primary.name
    }
  }
}

module "runbooks" {
  source  = "codectl/aa/azure//modules/runbooks"
  version = "~> 1.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location
  automation_account  = module.automation_account.account.name

  runbooks = local.runbooks
}

module "automation_account" {
  source  = "codectl/aa/azure"
  version = "~> 1.0"

  account = {
    name                = module.naming.automation_account.name_unique
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location
  }
}
