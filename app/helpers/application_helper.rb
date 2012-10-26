# -*- coding: utf-8 -*-

module ApplicationHelper

  def title(*parts)
    unless parts.empty?
      content_for :title do
        parts.unshift("Projekt Zespołowy").join(" | ")
      end
    end
  end

end
