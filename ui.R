library(shiny)

shinyUI(pageWithSidebar(

  headerPanel("Physicochemical properties viewer"),

  sidebarPanel(

    wellPanel(
      sliderInput("obs", 
                "Library Choice:", 
                min = 1, 
                max = 3, 
                value = 1),   
	
      selectInput(inputId = "x_var",
                  label = "X variable",
                  choices = c("molecular weight" = "MW",
                              "total polar surface area" = "TPSA",
                              "solubility" = "logP",
			      "number of charges" = "Ncharges",
			      "number of rings" = "RINGS"),
                  selected = "index"
                 ),

#MF MW Ncharges C H N O S Br K Cl Zn P Na I F Ca Se Cu As Cd Hg Pt RNH2 R2NH R3N ROPO3 ROH RCHO RCOR RCOOH RCOOR ROR RCCH RCN RINGS AROMATIC

      uiOutput("x_range_slider")
    ),


    wellPanel(
      selectInput(inputId = "y_var",
                  label = "Y variable",
		  choices = c("molecular weight" = "MW",
                              "total polar surface area" = "TPSA",
                              "solubility" = "logP",
			      "number of charges" = "Ncharges",
		              "number of rings" = "RINGS"),
                  selected = "molecular weight"
                 ),

      uiOutput("y_range_slider")
    ),

    checkboxInput(inputId = "Bioactivity",
                  label = "Activity in planta",
                  value = FALSE),

    wellPanel(
      p(strong("Model predictions")),
      checkboxInput(inputId = "mod_linear",    label = "Linear (dot-dash)"),
      checkboxInput(inputId = "mod_quadratic", label = "Quadratic (dashed)"),
      checkboxInput(inputId = "mod_loess",     label = "Locally weighted LOESS (solid)"),
      conditionalPanel(
        condition = "input.mod_loess == true",
        sliderInput(inputId = "mod_loess_span", label = "Smoothing (alpha)",
          min = 0.15, max = 1, step = 0.05, value = 0.75)
      )
    )
  ),

  mainPanel(
    plotOutput(outputId = "main_plot"),

    conditionalPanel("input.mod_linear == true",
      p(strong("Linear model")),
      verbatimTextOutput(outputId = "mod_linear_text")
    ),

    conditionalPanel("input.mod_quadratic == true",
      p(strong("Quadratic model")),
      verbatimTextOutput(outputId = "mod_quadratic_text")
    ),

    conditionalPanel("input.mod_loess == true",
      p(strong("LOESS model")),
      conditionalPanel("input.Bioactivity == true",
        p("Note: categorical variable ", code("Bioactivity"),
          " cannot be used as a predictor in a LOESS model.",
          " (The plot above uses two separate models.)")
      ),
      verbatimTextOutput(outputId = "mod_loess_text")
    )

  )
))

