resource "helm_release" "osmseed" {
  name  = "osmseed-helm"
  repository = "https://devseed.com/osm-seed-chart"
  chart = "osm-seed"
  version = "0.1.0-n621.ha8f8daa"
  wait = false
  depends_on = [

  ]

  set {
    name = "cloudProvider"
    value = "azure"
  }

}
