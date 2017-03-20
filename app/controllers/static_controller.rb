class StaticController < ApplicationController
  def index
    @logs = Log.select('creator,owner,category,game,author,title,private,token,created_at').where(:private => false).order("created_at DESC").limit(10)
    @games = Hash[Game.all.collect {|g| [g.id, g.name] }.push([0, "Other"])]
    @categories = Hash[Category.all.collect {|c| [c.id, c.name] }.push([0, "Other"])]

    respond_to do |format|
      format.html
    end
  end

  def about
  end

  def thankyou
  end

  def faq
  end

  def notfound
  end

  def contact
  end

  def sendmail
    @sender = params[:email]
    @subject = params[:subject]
    @message = params[:message]
    if validate(@sender, @subject, @message)
      Contact.contact(@sender, @subject, @message).deliver
      flash[:success] = "Message sent successfully"
      redirect_to contact_path
    else
      flash[:error] = @error
      render 'contact'
    end
  end


  private
    def validate(sender, subject, message)
      @email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      if sender.blank? || subject.blank? || message.blank?
        @error = "Message not sent: Required information not filled"
        return false
      elsif subject.length >= 500
        @error = "Message not sent: Subject must be smaller than 500 characters"
        return false
    elsif sender[@email_regex].nil?
        @error = "Message not sent: Email not valid"
        return false
      else
        return true
      end
    end
end
