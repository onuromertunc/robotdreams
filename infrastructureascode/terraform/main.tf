# Azure Provider tanımlamasi
provider "azurerm" {
  features {}

  # Tenant ID ve Subscription ID ayarları
  tenant_id       = "4a70e5e7-3fa2-4e4f-bc0a-c3644fbd155c"
  subscription_id = "d18ab524-8803-4dd7-b547-8f1a302f5b0a"
}

# Resource Group Oluşturma
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West US 2"  # Bölge güncellendi
}

# Sanal Ağ (VNet) Oluşturma
resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location  # Düzeltilmiş kaynak ismi
  resource_group_name = azurerm_resource_group.example.name      # Düzeltilmiş kaynak ismi
}

# Alt Ağ (Subnet) Oluşturma
resource "azurerm_subnet" "example_subnet" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name     # Düzeltilmiş kaynak ismi
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP Adresi Oluşturma
resource "azurerm_public_ip" "example_public_ip" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location  # Düzeltilmiş kaynak ismi
  resource_group_name = azurerm_resource_group.example.name      # Düzeltilmiş kaynak ismi
  allocation_method   = "Static"
}

# Ağ Arayüzü (Network Interface) Oluşturma
resource "azurerm_network_interface" "example_nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location  # Düzeltilmiş kaynak ismi
  resource_group_name = azurerm_resource_group.example.name      # Düzeltilmiş kaynak ismi

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example_public_ip.id
  }
}

# Ubuntu Sanal Makine Oluşturma
resource "azurerm_linux_virtual_machine" "example_vm" {
  name                = "example-vm"
  resource_group_name = azurerm_resource_group.example.name      # Düzeltilmiş kaynak ismi
  location            = azurerm_resource_group.example.location  # Düzeltilmiş kaynak ismi
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.example_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")  # Bu alanı kendi SSH anahtarına göre düzenle
  }

  computer_name                   = "example-vm"
  disable_password_authentication = true
}

# VM'nin Public IP'sini Çıktı Olarak Almak
output "public_ip" {
  value = azurerm_public_ip.example_public_ip.ip_address
}
