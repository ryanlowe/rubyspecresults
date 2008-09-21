class EasyFormat
  def self.tab
    '<span class="tab">&nbsp;</span>'
  end
  
  def self.format(text, break_lines=true, max_length=nil)
    return "" if text.nil?
    text = text.to_s
    text.strip!
    output = Array.new
    lines = text.split($/)
    for line in lines
      original = String.new(line.strip)
      line = escape_html(line)
      line = replace_tabs(line)
      line.strip!
      line = link_urls(line)
      line = split_max_length(line,max_length) if break_lines and (line == original)
      output.push(line)
    end
    connector = break_lines ? "<br/>\n" : " "
    output.join(connector)
  end
  
  def self.split_max_length(line,max_length=nil)
    return line if max_length.nil?
    return line if line.nil? or line.length < 1
    return line if line.length <= max_length
    remainder = line
    out = ""
    while remainder.length > max_length
      max = remainder[0,max_length]
      remainder = remainder[max_length,remainder.length]
      out += max+"<br/>\n"
    end
    out+remainder
  end
  
  def self.replace_tabs(line)
    tabbed = line.split(/\t/)
    output = tabbed.join(" ").strip
    output = tab+output if !tabbed[0].nil? and tabbed[0].strip.length < 1 and output.length > 0
    output
  end
  
  def self.link_urls(text)
    protocols = ['http:','https:']
    for protocol in protocols
      re = Regexp.new(protocol+'(\S+)')
      if text =~ re
        md = re.match(text)
        url, ending = strip_last_punctuation(md[1])
        after = md.post_match
        if after =~ re
          after = link_urls(after)
        end
        output = md.pre_match
        url = protocol+url
        output += '<a class="external" href="'+url+'" title="'+url+'">'+url+'</a>'
        output += ending
        output += after
        text = output
      end
    end
    text
  end
  
  def self.strip_last_punctuation(text)
    url = text
    ending = ""
    re = /([[:punct:]])$/
    if text =~ re
      md = re.match(text)
      url = md.pre_match
      ending = md[1]
      if ending == "/" #directory in URL
        url += ending
        ending = ""
      end
    end
    [url, ending]
  end
  
  def self.escape_html(text)
    text.gsub(/[<]/,'&lt;').gsub(/[>]/,'&gt;')
  end
end