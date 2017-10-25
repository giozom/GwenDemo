# Gwen Demo
* Automating Web Application using Gwen.
* Gwen is a gherkin interpreter for driving automation with Given-When-Then statements (executable specifications)

# Firefox ESR Note
* Gwen-web will use Firefox as the default browser. It is recommended that you install the latest [Firefox ESR] if you run into issues with your current installation or if you do not have Firefox installed.
[Firefox ESR]: https://www.mozilla.org/en-US/firefox/organizations/

# Running features in this repo using Gwen
* ~/GwenDemo $<code>./gwen -b features/floodio/ -m features/floodio/FloodIO.meta -p gwen.properties -r reports/results</code>

# Test Result
* ~/reports/results/index.html

# Gwen REPL Commands
* Step 1: Launch Gwen REPL console <code>./gwen</code>

## Useful commands
* Display help <code>help</code>
* List all previously entered commands <code>history</code>
* Evaluate a step <code>Given|When|Then|And|But [step] </code>
* Exit console <code>exit|quit|bye</code>
* List all DSL from console <code>gwen>Given I (then press Tab)</code>

# Screenshot
![Alt text](https://github.com/giozom/GwenDemo/blob/master/GwenResults.png "Gwen Report")

---

# More about Gwen
* About the Interpreter - https://github.com/gwen-interpreter/gwen
* About the Automation Engine - https://github.com/gwen-interpreter/gwen-web

# Gwen DSL 
* Gwen Web DSL - http://htmlpreview.github.io/?https://github.com/gwen-interpreter/gwen-web/blob/master/docs/dsl/gwen-web-dsl.html

