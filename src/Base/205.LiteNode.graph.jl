# #HERE
# - The interface of runtime objs graph
# - The kernel expose a DOM kind of structure

# #TODO
# - Actually, just clone the DOM interface
# - getById, etc

# return the main root parent
rootparent(::AbstractLiteNode) = error("Non implemented")

# return the main parent
parent(::AbstractLiteNode) = error("Non implemented")

# return a main child
child(::AbstractLiteNode) = error("Non implemented")

# return an array of parents
parents(::AbstractLiteNode) = error("Non implemented")

# return an array of childs
children(::AbstractLiteNode) = error("Non implemented")

# [try to] return a lazy iter (like a Channel) across each child
children_iter(::AbstractLiteNode) = error("Non implemented")

# [try to] return a lazy iter (like a Channel) across each parent
parents_iter(::AbstractLiteNode) = error("Non implemented")


locator(::AbstractLiteNode, ::AbstractLocatorSpec) = error("Non implemented")