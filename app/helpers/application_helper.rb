module ApplicationHelper
    def slugify(txt)
        txt.gsub(/[^0-9a-z ]/i, '').parameterize
    end
end
