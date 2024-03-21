# frozen_string_literal: true

module ApplicationHelper
  def default_meta_tags
    {
      site: 'Zero Steps',
      title: 'ゼロ高生向けの目標共有アプリ',
      reverse: true,
      charset: 'utf-8',
      description: 'Zero Stepsを使えば目標をタスク化し、進捗などを共有して励まし合えます！',
      keywords: 'ゼロ高,目標,タスク,共有',
      canonical: request.original_url,
      separator: '|',
      og: default_og,
      twitter: default_twitter
    }
  end

  private

  def default_og
    {
      site_name: :site,
      title: :title,
      description: :description,
      type: 'website',
      url: request.original_url,
      image: image_url('ogp.png'),
      local: 'ja-JP'
    }
  end

  def default_twitter
    {
      card: 'summary_large_image',
      site: '@yocchan_x',
      image: image_url('ogp.png')
    }
  end
end
