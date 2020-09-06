class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 今日の日付け(年月日)が入ってる

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)
    # .whereで(dateカラムの今日の日付〜7日後の日付)に一致する値を持ってきて代入。

    7.times do |x|
      today_plans = []
      plan = plans.map do |plan|
      # .mapメソッドで今日の日付から7日後までの要素を一つずつ処理を繰り返してplanに代入。
        today_plans.push(plan.plan) if plan.date == @todays_date + x
        # 1回目の処理なら→今日の日付＋1回目の処理(x=0)の数字が同じなら、today_plansの配列に日付をいれる。
      end
      wday_num = Date.today.wday + x
      # Date.today.wdayを利用して添字となる数値を得る（例:日曜は添字が0）。
      # 取得した添字にブロック変数のxを処理毎にプラスさせる。
      if wday_num >= 7
        wday_num = wday_num - 7
        # 曜日の添字が7以上ならー7して代入。
      end
      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans, wday: wdays[wday_num]}
      # month(キー):取得した日付の月の値（バリュー)と、日のキーバリューと、plans(キー):today_plansの配列(バリュー)と、曜日のキーバリューをdaysに代入。

      @week_days.push(days)
      # @week_daysの配列にdaysで取得した値を入れる。
    end

  end
end
