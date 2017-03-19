require 'test_helper'

class AST::NavigatorTest < Minitest::Test
  attr_reader :navigator

  def setup
    super
    @navigator = AST::Navigator.new
  end

  def test_parent
    ast = AST::Node.new(:node1, [
      AST::Node.new(:node1_1),
      AST::Node.new(:node1_2, [
        AST::Node.new(:node1_2_1),
        AST::Node.new(:node1_2_2)
      ])
    ])

    navigator.add_root_node(ast)

    assert_nil navigator.parent(ast)
    assert_equal :node1_2, navigator.parent(ast.children[1].children[0]).type
  end

  def test_ancestors
    ast = AST::Node.new(:node1, [
      AST::Node.new(:node1_1),
      AST::Node.new(:node1_2, [
        AST::Node.new(:node1_2_1),
        AST::Node.new(:node1_2_2)
      ])
    ])

    navigator.add_root_node(ast)

    assert_equal [:node1], navigator.ancestors(ast).map(&:type)
    assert_equal [:node1, :node1_1], navigator.ancestors(ast.children[0]).map(&:type)
    assert_equal [:node1, :node1_2, :node1_2_1], navigator.ancestors(ast.children[1].children[0]).map(&:type)
  end

  def test_children
    ast = AST::Node.new(:node1, [:foo, :bar, AST::Node.new(:node1_3)])
    navigator.add_root_node(ast)

    assert_equal [AST::Node.new(:node1_3)], navigator.each_child(ast).to_a
  end

  def test_siblings
    ast = AST::Node.new(:node1, [:foo, AST::Node.new(:node1_2), AST::Node.new(:node1_3)])
    navigator.add_root_node(ast)

    assert_equal [AST::Node.new(:node1_2), AST::Node.new(:node1_3)], navigator.each_sibling(ast.children[1]).to_a
  end

  def test_each_subnode
    ast = AST::Node.new(:node1, [
      AST::Node.new(:node1_1),
      AST::Node.new(:node1_2, [
        AST::Node.new(:node1_2_1),
        AST::Node.new(:node1_2_2),
        :foo
      ])
    ])

    navigator.add_root_node(ast)

    assert_equal 4, navigator.each_subnode(ast).count
    assert_equal 2, navigator.each_subnode(ast.children[1]).count
  end

  def test_each_root
    ast1 = AST::Node.new(:node1)
    ast2 = AST::Node.new(:node1)

    navigator.add_root_node(ast1)
    navigator.add_root_node(ast2)

    assert_equal 2, navigator.each_root.count
    assert navigator.each_root.any? {|root| root.equal?(ast1) }
    assert navigator.each_root.any? {|root| root.equal?(ast2) }
  end

  def test_root?
    ast1 = AST::Node.new(:node1)
    ast2 = AST::Node.new(:node1)

    navigator.add_root_node(ast1)

    assert navigator.root?(ast1)
    refute navigator.root?(ast2)
  end

  def test_member?
    ast1 = AST::Node.new(:node1, [AST::Node.new(:node11)])
    ast2 = AST::Node.new(:node1, [AST::Node.new(:node11)])

    navigator.add_root_node(ast1)

    assert navigator.member?(ast1)
    assert navigator.member?(ast1.children.first)
    refute navigator.member?(ast2)
    refute navigator.member?(ast2.children.first)
  end
end
