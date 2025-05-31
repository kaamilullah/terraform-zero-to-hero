provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address          = "http://127.0.0.1:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "c6ecc847-06c0-f17e-1773-e402778b2c88"
      secret_id = "424abdbb-fff3-3480-dbd8-0bb2bfaa545f"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "secret"           // KV v2 mount point
  name  = "test-secret"      // Replace with the actual secret path you created
}

resource "aws_instance" "my_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name   = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"] // Adjust "foo" based on your actual key name
  }
}
