if (!require("librarian")){
  install.packages("librarian")
}
shelf(
  bslib,
  dplyr,
  fs,
  glue,
  htmltools,
  purrr,
  rmarkdown,
  quiet = T)

tagList(html_dependency_font_awesome())

d_Rmd <- tibble(
  Rmd  = list.files(pattern="^p_.*\\.Rmd$"),
  fm   = map(Rmd, yaml_front_matter),
  tech = map_chr(fm, function(fm) fm$params$tech),
  regions = map_chr(fm, function(fm) fm$params$regions))

get_cards <- function(tech = NULL, region = NULL){
  Rmds <- d_Rmd %>% pull(Rmd)
  if (!is.null(tech))
    Rmds <- d_Rmd %>% filter(tech == !!tech) %>% pull(Rmd)
  if (!is.null(region))
    Rmds <- d_Rmd %>% filter(regions == !!region) %>% pull(Rmd)

  src = lapply(Rmds, function(Rmd) { # Rmd = Rmds[1]
    knitr::knit_expand('_card.Rmd')
  })
  res = knitr::knit_child(text = unlist(src), quiet = TRUE)
  cat(res, sep = '\n')
}
