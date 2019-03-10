require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  setup do
    @blog0 = blogs(:blog_0)
    @blog1 = blogs(:blog_1)
  end

  test 'should get the correct tags' do
    assert_equal %w[ruby rails], @blog0.tags
  end

  test 'should query tags with matched single item array (1)' do
    assert_equal 1, Blog.where(
      'tags @> ARRAY[?]::varchar[]', ['ruby']
    ).where(id: @blog0.id).count
  end

  test 'should query tags with matched single item array (2)' do
    assert_equal 1, Blog.where(
      'tags @> ARRAY[?]::varchar[]', ['python']
    ).where(id: @blog1.id).count
  end

  test 'should query tags with matched multiple item array' do
    assert_equal 1, Blog.where(
      'tags @> ARRAY[?]::varchar[]', %w[ruby rails]
    ).where(id: @blog0.id).count
  end

  test 'should able to empty result if query with non-matched array' do
    assert_equal 0, Blog.where(
      'tags @> ARRAY[?]::varchar[]', %i[ruby python]
    ).count
  end
end
