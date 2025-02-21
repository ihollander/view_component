# frozen_string_literal: true

require "test_helper"

class ViewComponentSystemTest < ViewComponent::SystemTestCase
  driven_by :cuprite

  def test_simple_js_interaction_in_browser_without_layout
    with_rendered_component_path(render_inline(SimpleJavascriptInteractionWithJsIncludedComponent.new)) do |path|
      visit path

      assert find("[data-hidden-field]", visible: false)
      find("[data-button]", text: "Click Me To Reveal Something Cool").click
      assert find("[data-hidden-field]", visible: true)
    end
  end

  def test_simple_js_interaction_in_browser_with_layout
    with_rendered_component_path(render_inline(SimpleJavascriptInteractionWithoutJsIncludedComponent.new), layout: "application") do |path|
      visit path

      assert find("[data-hidden-field]", visible: false)
      find("[data-button]", text: "Click Me To Reveal Something Cool").click
      assert find("[data-hidden-field]", visible: true)
    end
  end

  def test_component_with_params
    with_rendered_component_path(render_inline(TitleWrapperComponent.new(title: "awesome-title"))) do |path|
      visit path

      assert find("div", text: "awesome-title")
    end
  end

  def test_components_with_slots
    with_rendered_component_path(render_inline(SlotsV2Component.new) do |component|
      component.title do
        "This is my title!"
      end
    end) do |path|
      visit path

      find(".title", text: "This is my title!")
    end
  end
end
