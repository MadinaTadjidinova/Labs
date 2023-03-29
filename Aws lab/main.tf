# 1) Create a user devops and group engineers. (use this user for future deploys)
resource "aws_iam_user" "devops" {
  name = "devops"
}

resource "aws_iam_group" "engineer" {
  name = "engineer"
}

resource "aws_iam_group_membership" "devops_engineer" {
  name  = "devops_engineer"
  users = [aws_iam_user.devops.name]
  group = aws_iam_group.engineer.name
}
# 2) Create no public S3 for terraform state file
resource "aws_s3_bucket" "terraform_state" {
  bucket = "madinasbucket-terraform"
  acl    = "private"
  tags = {
    Name = "My Example Bucket"
  }
}

# 3) Deploy RDS Mysql 
resource "aws_db_instance" "mysql" {
  allocated_storage    = 10
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = false
  tags = {
    Name = "My MySQL DB"
  }
}

# 4) Create devx database and table users in it. The table should be with username, UID, GID, homedir columns. 
resource "aws_db_instance" "example" {
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  allocated_storage = 10
  storage_type = "gp2"
  username = "devops"
  password = "devops1234"
  db_name = "devx"
}

resource "aws_db_instance" "example1" {
  depends_on = [aws_db_instance.example]
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  allocated_storage    = 20
  db_name              = "example1"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql8.0"

  provisioner "local-exec" {
    command = "mysql -h ${aws_db_instance.example.endpoint} -u ${aws_db_instance.example.username} -p${aws_db_instance.example.password} -e 'CREATE TABLE users (username VARCHAR(255), UID VARCHAR(255), GID VARCHAR(255), homedir VARCHAR(255))'"
  }
}