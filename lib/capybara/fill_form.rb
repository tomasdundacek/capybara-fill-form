# frozen_string_literal: true

module Capybara
  module FillForm
    def fill_form(prefix = '', attributes = {})
      attributes.each do |key, val|
        field_key = "#{prefix}[#{key}]"
        if Hash === val
          fill_form(field_key, val)
        else
          field_key += '[]' if Array === val
          field = find_field field_key
          _fill_field(field, val)
        end
      end
    end

    def _fill_field(element, value)
      case element.tag_name
      when 'input', 'textarea' then _fill_input(element, value)
      when 'select'            then _select_values(element[:name], value)
      end
    end

    def _fill_input(element, value)
      method_to_call = case element[:type]
                      when 'radio'    then method(:_choose_value)
                      when 'checkbox' then method(:_check_values)
                      else                 method(:_fill_text)
                      end

      method_to_call.call(element[:name], value)
    end

    def _fill_text(name, value)
      fill_in(name, with: value)
    end

    def _select_values(name, values)
      Array(values).each do |val|
        select val, from: name
      end
    end

    def _choose_value(name, value)
      choose value, name: name
    end

    def _check_values(name, values)
      Array(values).each do |val|
        check val, name: name
      end
    end
  end
end
