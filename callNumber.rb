class CallNumber
	attr_reader :type_char, :type_num, :author_name, :author_num,:copy_num,:revision,:works,:area,:book_type,:tp_language,:group
	def initialize(callnumber_string)
        @callnumber_string=callnumber_string.strip.rstrip
		@type_all, @author_all = callnumber_string.split('/')
		@type_char=@type_all[/^[A-Z]+/]
		@type_num_init=@type_all[/\d.*$/]
        @type_num=''
		@type_num=@type_num_init[/^[\d|\.|=]+/] unless @type_num_init.nil?
		@book_type=''
		if @type_num_init =~ /-(\d+)/
			@book_type=$1
		end
		@group=''
		if @type_num_init =~ /:(([A-Z]|\d)+\d)/
			@group=$1
		end
		@tp_language=''
		if !@type_num_init.nil?  && @type_num_init.gsub(/:(([A-Z]|\d)+\d)/,'') =~ /([A-Z]+)/
			@tp_language=$1
		end
		@author_name=''
		@author_name=@author_all[/^[a-zA-Z]+/] unless @author_all.nil?
		@author_num_with_version=@author_all[/\d.*$/] unless @author_all.nil?
		@author_num_init,@copy=@author_num_with_version.split(/\s+/) unless @author_num_with_version.nil?
		@copy_num = 0
        @copy_num = @copy[/\d+/].to_i  unless @copy.nil?
        @author_num = 0
		@author_num=@author_num_init[/^\d+/].to_i unless @author_num_init.nil?
		@revision=''
        if @author_num_init =~ /=(\d+)/
			@revision=$1
		end
        @works=''
		if @author_num_init =~ /\((\d+)\)/
			@works=$1
		end
        @area=''
		if @author_num_init =~ /-(\d+)/
			@area=$1
		end

	end
    def to_s
        @callnumber_string
    end
	def <=>(other)
        result=0
        result=self.type_char <=> other.type_char  
    	############################分类号排序
		# self_str=self.type_num
		# other_str=other.type_num
		# i = 0
		# self_str.each_char do |c|
		# 	if other_str[i].nil?
		# 		result=1
		# 		break
		# 	end
		# 	unless c == other_str[i]
		# 		if c == '.'
		# 			result = -1
		# 		elsif other_str[i] == '.'
		# 			result = 1
		# 		else
		# 			result = c <=> other_str[i]
		# 		end
		# 		break
		# 	end
		# 	i+=1
		# end
        if result == 0
            result = self.type_num.gsub('=','-') <=> other.type_num.gsub('=','-')
        end
		############################分类号中特殊字段排序
		if result == 0
			result = self.tp_language <=> other.tp_language
		end
		if result == 0
			result = self.group <=> other.group
		end
		if result == 0
			result = self.book_type <=> other.book_type
		end
		#############################著者号排序
        if result == 0
            result = self.author_name <=> other.author_name
        end
        if result == 0
            result = self.author_num <=> other.author_num
        end
        if result == 0
            result = self.area <=> other.area
        end
        if result == 0
            result = self.works <=> other.works
        end
        if result == 0
            result = self.revision <=> other.revision
        end
        #############################副本排序
        if result == 0
            result = self.copy_num <=> other.copy_num
        end
		result
    end 
end


# callnumber= CallNumber.new('TP391.1C:K2-44/C66-22(12)=30 v.1')
# callnumber2= CallNumber.new('TP391.1C:K2-44/C66-22(12)=30 v.2')
# ar=[callnumber,callnumber2]
# p callnumber.type_num
# p callnumber.type_char
# p callnumber.author_name
# p callnumber.author_num
# p callnumber.copy_num
# p callnumber2.copy_num
# p callnumber.revision
# p callnumber.works
# p callnumber.area
# p callnumber.tp_language
# p callnumber.book_type
# p callnumber.group
# ar.sort!
# puts ar
# puts callnumber