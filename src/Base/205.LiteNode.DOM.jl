# HERE
# - we are implementing a DOM-like graph manipulation interface
# - we will streach the analogy till it is useful
# - mostly for the `get/quering` part of it

# MARK: DOM interface

# TODO: 
# Add `tk_` convention

########################
# Node identity & metadata
########################

# DOM: Returns an integer or symbol identifying the node kind (Element, Text, Record, Tape, etc).
tk_nodeType(::AbstractTKNode) = error("Non implemented")

# DOM: Returns a human-readable name for this node (e.g. tag name, record type, segment name).
tk_nodeName(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the scalar value associated with this node (like text content or literal value), if any.
tk_nodeValue(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the textual content of this node and all its descendants.
tk_textContent(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the root document / library / owning structure for this node.
tk_ownerDocument(::AbstractTKNode) = error("Non implemented")

########################
# Tree / graph structure
########################

# DOM: Returns the immediate parent node, or `nothing` if this node is a root.
tk_parentNode(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the nearest ancestor that is an element-like node (skips text or structural nodes).
tk_parentElement(::AbstractTKNode) = error("Non implemented")

# DOM: Returns all child nodes (including text-like or metadata nodes).
tk_childNodes(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the first child node, or `nothing`.
tk_firstChild(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the last child node, or `nothing`.
tk_lastChild(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the immediate previous sibling node, or `nothing`.
tk_previousSibling(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the immediate next sibling node, or `nothing`.
tk_nextSibling(::AbstractTKNode) = error("Non implemented")

# DOM: Returns true if this node has any children.
tk_hasChildNodes(::AbstractTKNode) = error("Non implemented")

# DOM: Returns true if the second node is a descendant of this node.
tk_contains(::AbstractTKNode, ::AbstractTKNode) = error("Non implemented")


########################
# Element-style traversal
########################

# DOM: Returns only the element-like children (filters out text, record metadata, etc).
tk_children(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the first child that is an element node.
tk_firstElementChild(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the last child that is an element node.
tk_lastElementChild(::AbstractTKNode) = error("Non implemented")

# DOM: Returns the number of element-like children.
tk_childElementCount(::AbstractTKNode) = error("Non implemented")


########################
# Structural mutation
########################

# DOM: Appends a child node to the end of this node's children.
tk_appendChild(::AbstractTKNode, ::AbstractTKNode) = error("Non implemented")

# DOM: Inserts a node before a reference child. If reference is `nothing`, appends.
tk_insertBefore(::AbstractTKNode, ::AbstractTKNode, ::AbstractTKNode) = error("Non implemented")

# DOM: Replaces an existing child with a new node.
tk_replaceChild(::AbstractTKNode, ::AbstractTKNode, ::AbstractTKNode) = error("Non implemented")

# DOM: Removes a child node from this node.
tk_removeChild(::AbstractTKNode, ::AbstractTKNode) = error("Non implemented")

# DOM: Creates a copy of this node. If `deep=true`, clone all descendants.
tk_cloneNode(::AbstractTKNode; deep::Bool = false) = error("Non implemented")


########################
# Selector-style querying
########################

# DOM: Returns the first descendant matching a selector expression.
tk_querySelector(::AbstractTKNode, ::AbstractString) = error("Non implemented")

# DOM: Returns all descendants matching a selector expression.
tk_querySelectorAll(::AbstractTKNode, ::AbstractString) = error("Non implemented")

