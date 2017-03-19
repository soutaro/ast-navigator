require "ast/navigator/version"

require "set"

module AST
  class Navigator
    attr_reader :parents
    attr_reader :roots

    def initialize()
      @parents = {}
      @roots = {}
    end

    def add_root_node(node)
      roots[node.__id__] = node

      node.children.each do |child|
        if child.is_a?(AST::Node)
          add_node(child, node)
        end
      end
    end

    def parent(node)
      parents[node.__id__]
    end

    def ancestors(node)
      ancestors = []

      current_node = node
      while current_node
        ancestors.unshift current_node
        current_node = parent(current_node)
      end

      ancestors
    end

    def each_subnode(node, &block)
      if block_given?
        each_child(node) do |child|
          yield child
          each_subnode child, &block
        end
      else
        enum_for :each_subnode, node
      end
    end

    def root?(node)
      roots.key?(node.__id__)
    end

    def member?(node)
      parent(node) || root?(node)
    end

    def each_root(&block)
      if block_given?
        roots.values.each(&block)
      else
        enum_for :each_root
      end
    end

    def each_child(node, &block)
      if block_given?
        node.children.select {|child| child.is_a?(AST::Node) }.each(&block)
      else
        enum_for :each_child, node
      end
    end

    def each_sibling(node, &block)
      if block_given?
        parent = parent(node)

        if parent
          each_child(parent, &block)
        else
          []
        end
      else
        enum_for :each_sibling, node
      end
    end

    private

    def add_node(node, parent)
      parents[node.__id__] = parent

      node.children.each do |child|
        if child.is_a?(AST::Node)
          add_node(child, node)
        end
      end
    end
  end
end
