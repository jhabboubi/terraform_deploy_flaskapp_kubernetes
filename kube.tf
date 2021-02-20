terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "flaskapp" {
  metadata {
    annotations = {
      name = "flaskapp"
    }

    labels = {
      App = "ScalableNginxExample"
    }

    name = "flaskapp"
  }
}


resource "kubernetes_deployment" "flaskapp" {
  metadata {
    namespace = kubernetes_namespace.flaskapp.metadata.0.name
    name = "scalable-nginx-example"
    labels = {
      App = "ScalableNginxExample"
    }
  }
  spec {
    replicas = 4
    selector {
      match_labels = {
        App = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
        }
      }
      spec {
        container {
          image = "tomkugelman/capstone-flask:latest"
          name  = "example"
          port {
            container_port = 80
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "nginx" {
  metadata {
    namespace = kubernetes_namespace.flaskapp.metadata.0.name
    name = "nginx-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.flaskapp.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}