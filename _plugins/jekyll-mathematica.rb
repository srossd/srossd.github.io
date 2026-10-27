require "jekyll"
require "json"
require "securerandom"
require "nokogiri"
require "tempfile"

module Jekyll
  class Mathematica

    class << self

      def mathematify(doc)
        matches = doc.content.scan(/```mma(-hide|-nocode)?(.*?)```/m)
        lines = matches.map { |match| match[1].strip }

        new_cells = lines.each_with_index.map do |line, index|
          {
            "cell_type" => "code",
            "execution_count" => index + 1,
            "id" => SecureRandom.hex(4),  # Generates an 8-character unique identifier
            "metadata" => {},
            "outputs" => [],
            "source" => line.lines
          }
        end

        if !Dir.exist?(".mma-cache")
          system("mkdir .mma-cache")
        end
        notebook_file = ".mma-cache/#{doc.basename_without_ext}.ipynb"
        notebook_html = ".mma-cache/#{doc.basename_without_ext}.html"
        final_notebook_file = "assets/notebooks/#{doc.basename_without_ext}.ipynb"

        changed = true
        if File.exist?(notebook_file)
          contents = File.read(notebook_file)
          if contents.strip.size > 0
            changed = false
            existing_data = JSON.parse(contents)
            existing_data["cells"].each_with_index do |cell, index|
              if cell["source"] != new_cells[index]["source"]
                changed = true
                break
              end
            end
          end
        end

        if changed && (ENV["CI"] || ENV["MMA_CACHE_ONLY"])
          raise "jekyll-mathematica: .mma-cache for '#{doc.basename_without_ext}' is missing or stale, and no Wolfram kernel is " \
                "available in this environment. Run `bundle exec jekyll build` locally (with the Wolfram Jupyter kernel), " \
                "then commit .mma-cache/ and assets/notebooks/."
        end

        if changed
          notebook = {
            "cells" => new_cells,
            "metadata" => {
              "kernelspec" => {
                "display_name" => "Wolfram Language 14.1",
                "language" => "Wolfram Language",
                "name" => "wolframlanguage14.1"
              },
              "language_info" => {
                "codemirror_mode" => "mathematica",
                "file_extension" => ".m",
                "mimetype" => "application/vnd.wolfram.m",
                "name" => "Wolfram Language",
                "pygments_lexer" => "mathematica",
                "version" => "12.0"
              }
            },
            "nbformat" => 4,
            "nbformat_minor" => 5
          }.to_json

          File.open(notebook_file, "w") do |file|
            file.write(notebook)
          end

          system("jupyter nbconvert --execute --to notebook --inplace #{notebook_file}")
          system("jupyter nbconvert --to html #{notebook_file} --HTMLExporter.theme=dark")
          system("sed -i '/<style type=\"text\/css\">/,/<\/style>/d' #{notebook_html}")
        end

        if !File.exist?(final_notebook_file)
          system("(echo '{% raw %}'; cat #{notebook_file}; echo '{% endraw %}') > #{final_notebook_file}")
        end
          
        html_output = `cat #{notebook_html}`

        html = Nokogiri::HTML(html_output)
        jp_cells = html.css('div.jp-Cell')

        doc.content = doc.content.gsub(/```mma(.*?)```/m).with_index { |match, i| 
          if matches[i][0] == '-nocode'
            jp_cells[i].search(".jp-Cell-inputWrapper").each do |src|
              src.remove
            end
          end
          if matches[i][0] == '-hide'
            ""
          else
            "{% raw %}<div class='jp-Notebook'>#{jp_cells[i]}</div>{% endraw %}"
          end 
        }
        doc.data['notebook'] = final_notebook_file
      end

      def mathematifiable?(doc)
        ((doc.is_a?(Jekyll::Page) || doc.write?) &&
          doc.output_ext == ".html" || (doc.permalink&.end_with?("/"))) && doc.content.scan(/```mma(.*?)```/m).count > 0
      end

      def changed?(file, code)
        File.open(file, 'r') do |file|
          file.read != code
        end
      end
    end
  end
end

Jekyll::Hooks.register [:posts], :pre_render do |doc|
  if Jekyll::Mathematica.mathematifiable?(doc)
    Jekyll::Mathematica.mathematify(doc)
  end
end
