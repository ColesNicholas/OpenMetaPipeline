# OpenMetaPipeline
Code for the 'Open MetaPipeline' prototype: an open, crowd-sourced meta-analysis project. The prototype can be viewed at https://nicholas-coles.shinyapps.io/scripts/.

To get started, download all .R files to a single local directory. Then open app.R.

app.R first calls seperate scripts to (a) download/analyze the data (meta.pipeline.analyses.R), (b) make funnel plots ("meta.pipeline.funnel.R" & "meta.pipeline.funnel.mod.R"), and (c) prepare html messages that will appear in the Shiny app ("meta.pipeline.msgs.R").

The UI component of the App creates two application pages. The first displays all the results, the second displays list of contributors.

The server component builds input that is called in the UI component.

Feel free to contact me with questions. I would be happy to chat via Skype/phone/email/Twitter

## News
10/11/18: I am currently working to with Hans IJzerman to make an Open MetaPipeline for a meta-analysis on social thermoregulation. Once this is complete, I will link the final project to this GitHub page. 
