# `lsp = require("lsp-lib")`

<%- lsp_lib.desc %>

<% for name, field in pairs(lsp_lib.fields) do %>
## `lsp.<%= name %>`

```
<%- field.view %>
```

<%- field.desc %>

<% end %>