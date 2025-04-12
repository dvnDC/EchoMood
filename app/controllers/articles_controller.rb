class ArticlesController < ApplicationController
  before_action :set_articles

  def show
    render "articles/#{params[:id]}"
  rescue ActionView::MissingTemplate
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def index
    @articles = [
      { id: 'introduction', title: 'Introduction to Emotion Tracking' },
      { id: 'methods', title: 'Emotion Tracking Methods' },
      { id: 'benefits', title: 'Benefits of Emotion Tracking' },

      { id: 'movement', title: 'Movement is medicine', category: 'advanced' },
      { id: 'meditation', title: 'Meditation', category: 'advanced' },
      { id: 'patterns', title: 'Analyzing Emotion Patterns', category: 'advanced' },
      { id: 'emotional-intelligence', title: 'Emotional Intelligence', category: 'advanced' },
      { id: 'case-studies', title: 'Case Studies', category: 'advanced' },
      { id: 'research', title: 'Scientific Research', category: 'advanced' },

      { id: 'resources', title: 'Resources and Further Reading' }
    ]

    @standard_articles = @articles.reject { |article| article[:category] == 'advanced' }
    @advanced_articles = @articles.select { |article| article[:category] == 'advanced' }
  end

  private

  def set_articles
    @articles = [
      { id: 'introduction', title: 'Introduction to Emotion Tracking' },
      { id: 'methods', title: 'Emotion Tracking Methods' },
      { id: 'benefits', title: 'Benefits of Emotion Tracking' },

      { id: 'movement', title: 'Movement is medicine', category: 'advanced' },
      { id: 'meditation', title: 'Meditation', category: 'advanced' },
      { id: 'patterns', title: 'Analyzing Emotion Patterns', category: 'advanced' },
      { id: 'emotional-intelligence', title: 'Emotional Intelligence', category: 'advanced' },
      { id: 'case-studies', title: 'Case Studies', category: 'advanced' },
      { id: 'research', title: 'Scientific Research', category: 'advanced' },

      { id: 'resources', title: 'Resources and Further Reading' }
    ]

    @standard_articles = @articles.reject { |article| article[:category] == 'advanced' }
    @advanced_articles = @articles.select { |article| article[:category] == 'advanced' }
  end
end